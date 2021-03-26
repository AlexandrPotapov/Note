enum Config {
    
    enum GistApi: String {
        
        case clientId = "some-client-id"
        case clientSecret = "some-client-secret"
        case redirectScheme = "redirect-scheme"
        
        case gistFilename = "gist-filename"
        
        enum Url: String {
            case auth = "https://github.com/login/oauth/authorize"
            case token = "https://github.com/login/oauth/access_token"
            case gist = "https://api.github.com/gists"
        }
    }
}
