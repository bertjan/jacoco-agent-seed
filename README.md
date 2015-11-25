# jacoco-agent-seed
Project skeleton for measuring end-to-end test coverage on a running Linux test environment with Jacoco agent.

## Usage

### Installation
```
wget https://raw.githubusercontent.com/bertjan/jacoco-agent-seed/master/coverage-report.sh  
wget https://raw.githubusercontent.com/bertjan/jacoco-agent-seed/master/coverage-setup.sh  
wget https://raw.githubusercontent.com/bertjan/jacoco-agent-seed/master/coverage.properties
```


### Configuration
Edit coverage.properties and configure the following keys for your project:
* appHealthCheckURL
* appStopCommand
* appStartCommand
* appClassesDir
* packagesToAnalyze
* packagePrefix
