function what_am_reviewing(url) {
  var iframe = document.createElement("iframe");
  iframe.setAttribute("style", "width: 100%; height: 100%; margin:0; padding: 0; border: 0; background: rgba(255,255,255,0.95);")
  var iframe_src = url;
  if (iframe_src.indexOf("?") == -1) {
    iframe_src = iframe_src + "?";
  } else {
    iframe_src = iframe_src + "&"
  }

  iframe_src = iframe_src + "frame=true";
  iframe.src = iframe_src;

  var container = document.createElement("div");
  container.setAttribute("style", "position: absolute; right:0; top: 0; width: 300px; height: 100px;");
  container.appendChild(iframe);

  document.body.appendChild(container);
}