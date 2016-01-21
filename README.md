# jacoco-agent-seed
Project skeleton for measuring end-to-end test coverage on a running Linux test environment with Jacoco agent.

## Usage

### Installation
Prerequisite: 'wget' must be installed.
```
wget https://raw.githubusercontent.com/bertjan/jacoco-agent-seed/master/install.sh && chmod +x install.sh && ./install.sh
```


### Configuration
Edit coverage.properties and configure the following keys for your project:
* appHealthCheckURL
* appStopCommand
* appStartCommand
* appClassesDir
* packagesToAnalyze
* packagePrefix


### Preparation
Enable the JaCoCo agent:  
```sudo ./coverage-setup.sh```

### Execution
Execute your (automated) tests, the JaCoCo agent will record coverage data.

### Reporting
Generate the report(s):  
```sudo ./coverage-report.sh```