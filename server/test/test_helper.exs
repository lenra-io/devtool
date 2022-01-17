ExUnit.start()
# Initialize the App stub (start the app stub Agent)
DevTool.AppStub.init()
# Verify that the Bypass app is started before tests
Application.ensure_all_started(:bypass)
Application.ensure_all_started(:dev_tools)
