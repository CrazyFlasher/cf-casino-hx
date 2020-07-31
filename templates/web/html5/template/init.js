game = {};

window.addEventListener ("touchmove", function (event) { event.preventDefault (); }, { capture: false, passive: false });

var content = document.createElement("div");
content.id = "content";
content.style.cssText = "padding: 0px; top: 0px; left: 0px; width: 100%; height: 100%; position: fixed; pointer-events: all;";
document.body.appendChild(content);

lime.embed("Main", "content", 0, 0);