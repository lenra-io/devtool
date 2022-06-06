ExUnit.start()
# Ask SQL adapter to use sandbox connexion pool for the Lenra Repo
Ecto.Adapters.SQL.Sandbox.mode(DevTool.Repo, :manual)
# Initialize the App stub (start the app stub Agent)
DevTool.AppStub.init()
# Verify that the Bypass app is started before tests
Application.ensure_all_started(:bypass)
