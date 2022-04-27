alias DevTool.Repo

Repo.insert! %DevTool.Environment{id: 1}
Repo.insert! %DevTool.User{id: 1, email: "test-user@lenra.io"}
Repo.insert! ApplicationRunner.Datastore.new(1, %{"name" => "UserData"})
