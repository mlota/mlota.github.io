---
layout: post
title: Code block testing
subtitle: Lorem ipsum dolor sit amet
---

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper neque eu justo laoreet, sed egestas elit aliquam. Ut in dapibus lorem. Donec iaculis sem at ex lobortis iaculis. Aenean ac gravida metus. In malesuada purus sit amet eros gravida vestibulum. Nullam laoreet gravida gravida. Sed eget quam est. Nulla eu egestas tellus, ut vulputate neque. Aliquam eu congue purus. Donec est mauris, varius at viverra luctus, vestibulum sed tortor. Proin pulvinar tortor id sem dapibus, ac tincidunt libero lacinia.

## HTML
{% highlight html %}
<div class="foo">
  <span>Hello world</span>
</div>
{% endhighlight %}

## JavaScript

{% highlight javascript %}
// Shorten the navbar after scrolling a little bit down
$(window).scroll(function() {
    if ($(".navbar").offset().top > 50) {
        $(".navbar").addClass("top-nav-short");
    } else {
        $(".navbar").removeClass("top-nav-short");
    }
});

// On mobile, hide the avatar when expanding the navbar menu
$('#main-navbar').on('show.bs.collapse', function () {
  $(".navbar").addClass("top-nav-expanded");
})
$('#main-navbar').on('hidden.bs.collapse', function () {
  $(".navbar").removeClass("top-nav-expanded");
})
{% endhighlight %}

## C# #
{% highlight csharp %}
using System;
using System.IO;

public class Foo
{
  private void Page_Load(object sender, EventArgs e)
  {
    Response.Write("Hello World!");
    var request = WebRequest.Create("http://www.google.com");
  }
}
{% endhighlight %}
