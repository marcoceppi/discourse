$(document).on("discourse:ready", function() {
    if (external.getUnityObject) {
        window.Unity = external.getUnityObject(1.0);

        // use the Apple touch icon as icon
        var icnsize=0, icnurl;
        Array.prototype.slice.call(document.querySelectorAll("link[rel='apple-touch-icon']")).forEach(function(icn) {
            var szs = (icn.getAttribute("sizes") || "").split("x");
            if (!icn.getAttribute("sizes")) szs = ["10","10"];
            if (szs.length === 2 && parseInt(szs[0], 10) > icnsize) {
                icnsize = parseInt(szs[0], 10);
                icnurl = icn.getAttribute("href");
                if (icnurl.match(/^\//)) { icnurl = location.origin + icnurl; }
            }
        });

        var user = Discourse.User.current();
        if (user) {
            Unity.init({
                name: Discourse.SiteSettings.title,
                iconUrl: icnurl,
                onInit: function() {
                    user.addObserver("unread_notifications", function() {
                        var ncount = user.get("unread_notifications");
                        if (ncount === 0) {
                            Unity.MessagingIndicator.clearIndicators();
                            Unity.Launcher.clearCount();
                        } else {
                            Unity.MessagingIndicator.showIndicator("Mentions and replies", {count: ncount});
                            Unity.Launcher.setCount(ncount);
                        }
                    });
                }
            });
        }
    }
});
