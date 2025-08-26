1. Signin to rubygems with 
```bash
gem signin
``` 
2. update version in `version.rb`
3. build gem with
```bash
gem build greentable.gemspec 
```
4. publish newly built gem
```bash
gem push greentable-0.9.7.gem
```
