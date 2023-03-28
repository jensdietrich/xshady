# xshady

This repo contains some projects that demonstrate the precense of vulnerabilities in libraries that use shading. The focus is on libraries not using the [shade plugin](https://maven.apache.org/plugins/maven-shade-plugin/) or similar, i.e. project that do not have meta data that allow dependency scanners to detect those vulnerabilities. Results are discovered with a toolchain we are building, aiming at discovering blindspots in existing SCA tools. 

## Repository Structure

The top level folders have names corresponding to the (slightly modified to make it a valid file name) Maven coordinates of a vulnerable component that is being shaded. 

This subfolders then have a subfolder with the same name, containing a maven project with test(s) illustrating a vulnerability. Dependeabot and similar tools will detect those vulnerabilities as expected.

Other subfolders contain projects where the vulnerable library is shaded (or sometimes just copied, i.e. without renaming packages), plus tests to illustrate the respective vulnerability. The intersting part is that existing security scanners do not pick this up. 



## Running Software Composition Security Analyses

The projects can be used to test various SCA tools as follows: 

### Dependabot 

The analysis is run on GitHub, check the dependabopt [result page](https://github.com/jensdietrich/xshady/security/dependabot) for the projects detected as being vulnerable.

### IntelliJ IDEA 2022.2 (Ultimate Edition) / CheckMarx

IntelliJ has built-in support to detect vulnerable dependencies. To run this analysis requires to load the respective projects into the IDE. Then click on the project's `pom.xml`, and run `Analyze > Show Vulnerable Dependencies`. This will display a view with vulnerable dependencies. 

This functionality is based on [checkmarx](https://checkmarx.com/). 


### OWASP Dependency Check

Each projects pom includes the [dependency-check plugin](https://mvnrepository.com/artifact/org.owasp/dependency-check-maven/8.1.2). 

To run the analysis, cd into the project folder, and run  `mvn verify -Dsnyk.skip`.  The extra parameter is needed to disable the snyk plugin also present in the poms, that may interfere with the dependency check. This will take some time when used for the first time as CVE info needs to be downloaded. The results are saved in a report in `target/dependency-check-report.html`.


### Snyk

Each project's pom includes the [snyk Maven plugin](https://docs.snyk.io/integrations/ci-cd-integrations/maven-plugin-integration). To run the analysis, run  

`mvn test -Dsnyk.apitoken=<api-token>`

This requires an *api-token* that can be obtained [here](https://docs.snyk.io/snyk-api-info/authentication-for-api). 

Vulnerabilities found will be reported in the console output, this looks somehow like this:

```
[INFO] Tested 1 dependencies for known issues, found 1 issue, 1 vulnerable path.
[INFO] 
[INFO] Issues to fix by upgrading:
[INFO] 
[INFO]   Upgrade org.apache.commons:commons-collections4@4.0 to org.apache.commons:commons-collections4@4.1 to fix
[INFO]   ✗ Deserialization of Untrusted Data [Critical Severity][https://security.snyk.io/vuln/SNYK-JAVA-ORGAPACHECOMMONS-30008] in org.apache.commons:commons-collections4@4.0
[INFO]     introduced by org.apache.commons:commons-collections4@4.0

```

The snyk plugin crashes after reporting vulnerabilities (reasons yet unknown). 

 




  


 

 

