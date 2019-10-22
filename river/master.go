package river

import (
	"bytes"
	"sync"
	"time"

	"github.com/BurntSushi/toml"
	"github.com/juju/errors"
	"github.com/siddontang/go-log/log"
	"github.com/siddontang/go-mysql/mysql"
	"github.com/siddontang/go/ioutil2"
)

type masterInfo struct {
	sync.RWMutex

	Name  string `toml:"bin_name"`
	Pos   uint32 `toml:"bin_pos"`
	SGtid string `toml:"bin_gtid"`
	gset  mysql.GTIDSet

	filePath     string
	lastSaveTime time.Time
}

// TODO: add gtidset, what about update gtid ?
func (m *masterInfo) Save(pos mysql.Position, gtid string) error {
	log.Infof("save position %s, gtid: %s", pos, gtid)

	m.Lock()
	defer m.Unlock()

	m.Name = pos.Name
	m.Pos = pos.Pos
	m.SGtid = gtid

	if len(m.filePath) == 0 {
		return nil
	}

	n := time.Now()
	if n.Sub(m.lastSaveTime) < time.Second {
		return nil
	}

	m.lastSaveTime = n
	var buf bytes.Buffer
	e := toml.NewEncoder(&buf)

	e.Encode(m)

	var err error
	if err = ioutil2.WriteFileAtomic(m.filePath, buf.Bytes(), 0644); err != nil {
		log.Errorf("canal save master info to file %s err %v", m.filePath, err)
	}

	return errors.Trace(err)
}

// TODO: add get gtid set for startWithGtid
func (m *masterInfo) Position() mysql.Position {
	m.RLock()
	defer m.RUnlock()

	return mysql.Position{
		Name: m.Name,
		Pos:  m.Pos,
	}
}

func (m *masterInfo) GtidSet() mysql.GTIDSet {
	gtid, _ := mysql.ParseGTIDSet("mysql", m.SGtid)
	return gtid
}

func (m *masterInfo) Close() error {
	pos := m.Position()

	return m.Save(pos, m.SGtid)
}
