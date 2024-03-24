// ==UserScript==
// @name        github: remove right sidepanel on the main page
// @namespace   Violentmonkey Scripts
// @match       https://github.com/
// @grant       none
// @version     1.0
// @author      @woojiq
// @description Remove sidepanel that shows "Popular repositoriers", etc.
// ==/UserScript==

document.querySelector('aside.feed-right-sidebar').remove()
