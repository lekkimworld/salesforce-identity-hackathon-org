@RestResource(urlMapping='/nonce')
global class Hackathon_GenerateCachedNonce {
    
    @HttpGet
    global static void getNonce() {
        final String nonce = EncodingUtil.base64Encode(Crypto.generateAesKey(128)).remove('/').remove('=').remove('+');
        Cache.Org.put('local.Nonce.' + nonce, true);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('{"nonce": "' + nonce + '"}');
    }

    @HttpPost
    global static void getNonceWithLanguage(NonceWithLanguage data) {
        final String nonce = EncodingUtil.base64Encode(Crypto.generateAesKey(128)).remove('/').remove('=').remove('+');
        Cache.Org.put('local.Nonce.' + nonce, data.language);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('{"nonce": "' + nonce + '", "language": "' + data.language + '"}');
    }

    global class NonceWithLanguage {
        global String language;

    }
}
