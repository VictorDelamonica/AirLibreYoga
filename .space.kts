job("Deploy to space") {
  container(displayName = "Say Hello", image = "ubuntu") {
        shellScript {
            content = """
                echo "I can run shellScript only once!"
            """
        }
    }
    container(displayName = "Api", image = "amazoncorretto:17-alpine") {
        kotlinScript { api ->
            api.space().projects.automation.deployments.start(
                    project = api.projectIdentifier(),
                    targetIdentifier = TargetIdentifier.Key("release"),
                    version = "1.0.0",
                    // automatically update deployment status based on a status of a job
                    syncWithAutomationJob = true
            )
        }
    }
}

job("Test") {
    container(displayName = "Say Hello", image = "ubuntu") {
        shellScript {
            content = """
                echo "I can run shellScript only once!"
            """
        }
    }
}
