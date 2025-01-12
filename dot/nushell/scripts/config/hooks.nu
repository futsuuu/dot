export-env { $env.config = ($env.config | upsert hooks {
  pre_prompt: [{
    if $env.banner {
      print $nu.current-exe
      print ""
      print $"Startup time: ($nu.startup-time)"
      $env.banner = false
    }
  }]
}) }
