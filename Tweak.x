#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

static NSString *const kGitHubFixJS = @""
"(function() {"
"  if (!window.location.hostname.includes('github.com')) return;"
""
"  function applyFix() {"
"    /* 1. Нормализация meta viewport для мобильного экрана iOS 16 */"
"    var meta = document.querySelector('meta[name=\"viewport\"]');"
"    if (!meta) {"
"      meta = document.createElement('meta');"
"      meta.name = 'viewport';"
"      if (document.head) document.head.appendChild(meta);"
"    }"
"    if (meta) {"
"      meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover';"
"    }"
""
"    /* 2. Внедрение CSS-стилей для предотвращения горизонтального переполнения и сдвига */"
"    var styleId = 'github-safari-layout-fix';"
"    if (!document.getElementById(styleId)) {"
"      var style = document.createElement('style');"
"      style.id = styleId;"
"      style.type = 'text/css';"
"      style.innerHTML = `"
"        html, body {"
"          max-width: 100vw !important;"
"          width: 100% !important;"
"          overflow-x: clip !important;"
"          margin: 0 !important;"
"          padding: 0 !important;"
"        }"
"        body {"
"          position: relative !important;"
"        }"
"        .application-main, main, [role=\"main\"], .Layout, .Layout-main, .container-xl, .container-lg, #start-of-content, .AppHeader {"
"          max-width: 100vw !important;"
"          width: 100% !important;"
"          box-sizing: border-box !important;"
"          margin-left: auto !important;"
"          margin-right: auto !important;"
"        }"
"        *, *::before, *::after {"
"          box-sizing: border-box !important;"
"        }"
"        /* Предотвращаем расширение экрана таблицами и блоками кода */"
"        pre, code, table, .highlight, .blob-wrapper, .markdown-body pre, textarea {"
"          max-width: 100% !important;"
"          overflow-x: auto !important;"
"          -webkit-overflow-scrolling: touch !important;"
"          box-sizing: border-box !important;"
"        }"
"      `;"
"      if (document.head) {"
"        document.head.appendChild(style);"
"      } else if (document.documentElement) {"
"        document.documentElement.appendChild(style);"
"      }"
"    }"
"  }"
""
"  applyFix();"
"  if (document.readyState === 'loading') {"
"    document.addEventListener('DOMContentLoaded', applyFix);"
"  }"
"  window.addEventListener('load', applyFix);"
"  /* Поддержка SPA/Turbo навигации GitHub */"
"  document.addEventListener('turbo:render', applyFix);"
"  document.addEventListener('turbo:load', applyFix);"
"  window.addEventListener('popstate', applyFix);"
"})();";

%hook WKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (configuration && configuration.userContentController) {
        WKUserScript *scriptStart = [[WKUserScript alloc] initWithSource:kGitHubFixJS
                                                           injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                        forMainFrameOnly:NO];
        WKUserScript *scriptEnd = [[WKUserScript alloc] initWithSource:kGitHubFixJS
                                                         injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                      forMainFrameOnly:NO];
        [configuration.userContentController addUserScript:scriptStart];
        [configuration.userContentController addUserScript:scriptEnd];
    }
    return %orig(frame, configuration);
}

%end
