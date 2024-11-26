explorer "http://localhost:1313/"
cd %MySite%
hugo mod tidy
hugo mod npm pack
hugo server -w