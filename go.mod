module github.com/siddontang/go-mysql-elasticsearch

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/juju/errors v0.0.0-20190207033735-e65537c515d7
	github.com/kr/pretty v0.2.0 // indirect
	github.com/pingcap/errors v0.11.0
	github.com/siddontang/go v0.0.0-20180604090527-bdc77568d726
	github.com/siddontang/go-log v0.0.0-20180807004314-8d05993dda07
	github.com/siddontang/go-mysql v0.0.0-20191014070946-e4fc33683f45
)

replace github.com/siddontang/go-mysql v0.0.0-20191014070946-e4fc33683f45 => github.com/jianhaiqing/go-mysql v0.0.0-20200314034126-88c1f28de5b5

go 1.13
