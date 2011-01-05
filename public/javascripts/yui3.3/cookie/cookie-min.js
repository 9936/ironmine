YUI.add("cookie",function(C){var K=C.Lang,I=C.Object,G=null,D=K.isString,P=K.isObject,F=K.isUndefined,E=K.isFunction,H=encodeURIComponent,B=decodeURIComponent,N=C.config.doc;function J(L){throw new TypeError(L);}function M(L){if(!D(L)||L===""){J("Cookie name must be a non-empty string.");}}function A(L){if(!D(L)||L===""){J("Subcookie name must be a non-empty string.");}}C.Cookie={_createCookieString:function(Q,T,R,O){O=O||{};var V=H(Q)+"="+(R?H(T):T),L=O.expires,U=O.path,S=O.domain;if(P(O)){if(L instanceof Date){V+="; expires="+L.toUTCString();}if(D(U)&&U!==""){V+="; path="+U;}if(D(S)&&S!==""){V+="; domain="+S;}if(O.secure===true){V+="; secure";}}return V;},_createCookieHashString:function(L){if(!P(L)){J("Cookie._createCookieHashString(): Argument must be an object.");}var O=[];I.each(L,function(R,Q){if(!E(R)&&!F(R)){O.push(H(Q)+"="+H(String(R)));}});return O.join("&");},_parseCookieHash:function(S){var R=S.split("&"),T=G,Q={};if(S.length){for(var O=0,L=R.length;O<L;O++){T=R[O].split("=");Q[B(T[0])]=B(T[1]);}}return Q;},_parseCookieString:function(W,Y){var X={};if(D(W)&&W.length>0){var L=(Y===false?function(Z){return Z;}:B),U=W.split(/;\s/g),V=G,O=G,R=G;for(var Q=0,S=U.length;Q<S;Q++){R=U[Q].match(/([^=]+)=/i);if(R instanceof Array){try{V=B(R[1]);O=L(U[Q].substring(R[1].length+1));}catch(T){}}else{V=B(U[Q]);O="";}X[V]=O;}}return X;},_setDoc:function(L){N=L;},exists:function(L){M(L);var O=this._parseCookieString(N.cookie,true);return O.hasOwnProperty(L);},get:function(O,L){M(O);var S,Q,R;if(E(L)){R=L;L={};}else{if(P(L)){R=L.converter;}else{L={};}}S=this._parseCookieString(N.cookie,!L.raw);Q=S[O];if(F(Q)){return G;}if(!E(R)){return Q;}else{return R(Q);}},getSub:function(L,Q,O){var R=this.getSubs(L);if(R!==G){A(Q);if(F(R[Q])){return G;}if(!E(O)){return R[Q];}else{return O(R[Q]);}}else{return G;}},getSubs:function(L){M(L);var O=this._parseCookieString(N.cookie,false);if(D(O[L])){return this._parseCookieHash(O[L]);}return G;},remove:function(O,L){M(O);L=C.merge(L||{},{expires:new Date(0)});return this.set(O,"",L);},removeSub:function(O,S,L){M(O);A(S);L=L||{};var R=this.getSubs(O);if(P(R)&&R.hasOwnProperty(S)){delete R[S];if(!L.removeIfEmpty){return this.setSubs(O,R,L);}else{for(var Q in R){if(R.hasOwnProperty(Q)&&!E(R[Q])&&!F(R[Q])){return this.setSubs(O,R,L);}}return this.remove(O,L);}}else{return"";}},set:function(O,Q,L){M(O);if(F(Q)){J("Cookie.set(): Value cannot be undefined.");}L=L||{};var R=this._createCookieString(O,Q,!L.raw,L);N.cookie=R;return R;},setSub:function(O,R,Q,L){M(O);A(R);if(F(Q)){J("Cookie.setSub(): Subcookie value cannot be undefined.");}var S=this.getSubs(O);if(!P(S)){S={};}S[R]=Q;return this.setSubs(O,S,L);},setSubs:function(O,Q,L){M(O);if(!P(Q)){J("Cookie.setSubs(): Cookie value must be an object.");}var R=this._createCookieString(O,this._createCookieHashString(Q),false,L);N.cookie=R;return R;}};},"@VERSION@",{requires:["yui-base"]});