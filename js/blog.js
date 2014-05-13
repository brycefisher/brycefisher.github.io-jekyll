/* Private Scope */
;(function() {

  /* Universal Tracking Code */
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-39263610-1', 'fisher-fleig.org');
  ga('send', 'pageview');

  /* Disqus Commenting Widget */
  if ( document.getElementById('disqus_thread') ) {
    (function() {
      var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
      dsq.src = '//brycefisherfleig-blog.disqus.com/embed.js';
      (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
  }

  /* Conversion Metrics */
  function ga_convert(class_selector, category, action,) {
    var node_list = document.querySelectorAll(class_selector),
        i=0;
    if (node_list) {
      for (; i<node_list.length; i++) {
        node_list[i].addEventListener('click', callback, false);
      }
    }
  }
  ga_convert('.secondary-cta', function(e){
    ga('send', 'event', 'social', 'follow', 'rss', 1);
  });
  ga_convert('.primary-cta', function(){
    ga('send', 'event', 'social', 'follow', 'twitter', 1);
  });
  
})()
