def "nu-complete mise tasks" [context: string] {
  let parts = $context | split row " " | skip 1
  {
    options: {
       sort: false,
       completion_algorithm: substring,
       case_sensitive: false,
    }
    completions: ([])
  }
}
