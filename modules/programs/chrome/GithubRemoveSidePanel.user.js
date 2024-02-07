// ==UserScript==
// @name        github: remove right sidepanel on the main page
// @namespace   Violentmonkey Scripts
// @match       https://github.com/
// @grant       none
// @version     1.0
// @author      @woojiq
// @description 1/29/2024, 15:52:00 AM
// ==/UserScript==

document.querySelector('aside.feed-right-sidebar').remove()
