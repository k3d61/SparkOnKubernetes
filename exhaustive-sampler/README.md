File Structure:
    sed-config-generator.sh - generates all combinations of configs. Range of each parameter is defined in for loop in the script (change in the for loop to change the ranges). If you just want to know how many configs will be generated then just comment the sed command in the sed-config-generator.sh and run it which will tell how many configs are going to be generated.
    Input: (template file, algorithm name, person name, starting run id) 
            - sample template: kmeans.conf.template (available in tar.gz) (change the workload details only)
    Output: generated-configs (folder)
                - algo-person (folder)
                    - configs (folder)
                        - algo-person-runid.conf (all the configs generated)
                    - _metadata-algo-person.csv (this contains details of all the configs created)
    create-spark-bench-config.sh - copy all the configs of given id and generates a single config which is ready to run. By default parallel spark-submit is turned on. So if you want sequencial submit then after a single file is generated change the spark-submit-parallel = false in 2nd line of generated single config.
    Input: (copy_config_runids.txt , algo, person)
            - copy_config_runids.txt: run ids of config files. you can get this ids from the _metadata-algo-person.csv generated by sed-config-generator.sh. 
            Sample copy_config_runids.txt file: copy_config_runids (available in tar.gz)
    Output: copied-configs (folder) 
                - algo-person (folder)
                - _merged-algo-person.conf (this is the file you want to run
                - algo-person-runid.conf (files which are copied and merged in the _merged-algo-person.conf) (there will a little extra content added into _merged-algo-person.conf which you can see in script and change according to convinience like change the spark-submit-parallel parameter.
                    