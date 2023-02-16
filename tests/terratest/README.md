# Usage
The go libraries are compiled at the root folder of waf module with below commands:

```
~/../waf$ go mod init waf
~/../waf$ go mod tidy
```


To run the tests execute the following:

```
$ go test -v -timeout 30m waf_test.go
```
