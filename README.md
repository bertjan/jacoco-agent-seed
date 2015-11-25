# jacoco-agent-seed
Project skeleton for measuring end-to-end test coverage on a running Linux test environment with Jacoco agent.

## Usage

### Installation
```wget https://raw.githubusercontent.com/bertjan/jacoco-agent-seed/master/coverage-report.sh  
wget https://raw.githubusercontent.com/bertjan/jacoco-agent-seed/master/coverage-setup.sh  
wget https://raw.githubusercontent.com/bertjan/jacoco-agent-seed/master/coverage.properties  ```


### Configuration
Edit coverage.properties, keys 'packagesToAnalyze' to 'packagePrefix' to (Java) packages for your project.
Example:
```
packagesToAnalyze=( "/com/company/package1" "/com/company/package2" )  
packagePrefix="/com/company/"```

