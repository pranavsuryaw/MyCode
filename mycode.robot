*** Settings ***
Resource         ../../Resources/ODS.robot
Resource         ../../Resources/Common.robot
Resource         ../../Resources/Page/ODH/JupyterHub/JupyterHubSpawner.robot
Resource         ../../Resources/Page/ODH/JupyterHub/JupyterLabLauncher.robot
Library          OpenShiftCLI
Library          DebugLibrary
Suite Setup      Server Setup
Suite Teardown   End Test


*** Variables ***
${REPO_URL} =    https://github.com/Pranav-Code-007/Python.git
${FILE_PATH} =   Python/file.ipynb
${user_name} =   ******
${email_id} =  ******
${commit_page} =  https://github.com/Pranav-Code-007/Python/commits/main
${name} =  Pranav
${commit_msg} =  commit msg1
${token} =  ******

*** Test Cases ***
# Have a remote repository configured
# File -> save all changes
# Click git -> simple staging
# Click git -> push to remote

Verify Pushing Project Changes Remote Repository
    [Tags]  ODS-326
    sleep  20s
    Clone Git Repository And Open    ${REPO_URL}    ${FILE_PATH}
    Sleep    5s
    Add and Run JupyterLab Code Cell in Active Notebook    print("Hi Hello")

#    Add And Run JupyterLab Code Cell  print("Hi Hello")
#    Sleep    5s
#    Add And Run Notebook Classic Code Cell  print("Hi Hello")
    Sleep    5s
    Log to Console  After Run JupyterLab Code Cell
    Wait Until JupyterLab Code Cell Is Not Active
    Log to Console  Wait Until JupyterLab
    Open With JupyterLab Menu  File  Save Notebook
    Log to Console  Open with Jl Menu File Save Nb
    Open With JupyterLab Menu  Git  Simple staging
    Log to Console  Open with JL Menu Git Simple Staging
   ## Close Other JupyterLab Tabs

#    Add And Run JupyterLab Code Cell
    # It is adding this code in fil.pynb file
   ## Add and Run JupyterLab Code Cell in Active Notebook  print("Hi")
#    Add And Run Notebook Classic Code Cell

   ## Open With JupyterLab Menu  File  Save All
    #-------------------
    # Click on git icon
    Click Element   xpath=//*[@id="tab-key-6"]/div[1]
    Log to Console  After clicking on git icon
    #-------------------
    Input Text    xpath=//*[@id="jp-git-sessions"]/div/form/input[1]    ${commit_msg}
    #click on commit button
    Sleep    2s
    Click Button    xpath=//*[@id="jp-git-sessions"]/div/form/input[2]   #or //*[@class='f58vw4a']
    Log to Console  After putting commit message and clicking on commit

    Wait Until Page Contains  Who is committing?

    Input Text    //input[@class='jp-mod-styled'][1]    ${name}
    Input Text    //input[@class='jp-mod-styled'][2]    ${email_id}


    Click Element    //button[@class='jp-Dialog-button jp-mod-accept jp-mod-styled']//div[2]    #click on submit

    #click on push to remote
    Open With JupyterLab Menu    Git    Push to Remote
    Log To Console    after clicking on push to remote
    Wait Until Page Contains    Git credentials required  timeout=200s

    # enter the credentials username and password

    Input Text    //input[@class='jp-mod-styled'][1]    ${user_name}
    Input Text    //input[@class='jp-mod-styled'][2]    ${token}
    Click Element    //button[@class='jp-Dialog-button jp-mod-accept jp-mod-styled']//div[2]    #click on submit

    Sleep  5s

    ${pod_name} =    Get User Notebook Pod Name    ${TEST_USER.USERNAME}
    ${op} =  Run  oc exec ${pod_name} -- git log --name-status HEAD^..HEAD
    Log To Console    ${op}
    ${contains}=  Evaluate   "${commit_msg}" in """${op}"""
    Should Be Equal     ${True}    ${contains}

    Go To    ${commit_page}
    Wait Until Page Contains    ${commit_msg}  timeout=200s

    # git log --name-status HEAD^..HEAD

    Clean Up User Notebook    ${OCP_ADMIN_USER.USERNAME}    ${TEST_USER.USERNAME}



#     [Arguments]    @{code}    ${n}=1

*** Keywords ***
Server Setup
    [Documentation]    Suite Setup
    Begin Web Test
    Launch JupyterHub Spawner From Dashboard
#    Spawn Notebook
    Spawn Notebook With Arguments    image=s2i-minimal-notebook    size=Default

#robot -i ODS-326 --variablefile test-variables.yml tests/Tests/500__jupyterhub/test-jupyterlab-git.robot
# $ oc exec <pod> [-c <container>] <command> [<arg_1> ... <arg_n>]
# ${pod_name} =    Get User Notebook Pod Name    ${TEST_USER.USERNAME}
# ${ver} =  Run  oc exec ${pod_name} git log --name-status HEAD^..HEAD
End Test
#    Clean Up User Notebook    ${OCP_ADMIN_USER.USERNAME}    ${TEST_USER.USERNAME}
    End Web Test


