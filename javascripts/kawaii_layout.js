(function(){$(function(){var a,e,r,t,n,o,s,c,d,i,l,h,f,u,g,p,v,y,w,b,j,m,k,x;for(e=6,n=6,t=1.2,r=.05,b=.1,i=.9,v=40,p=80,$("#add-art").on("click",function(a){var e,r,t,n,o;for(n=$("canvas"),o=[],r=0,t=n.length;t>r;r++)e=n[r],o.push(e.addArt());return o}),$("#toggle-show-bonds").on("click",function(a){var e,r,t,n,o;for(n=$("canvas"),o=[],r=0,t=n.length;t>r;r++)e=n[r],o.push(e.toggleShowBonds());return o}),y=$("canvas"),j=[],f=0,g=y.length;g>f;f++){for(s=y[f],d=$(s),l=new createjs.Point(d.data("gravity-x"),d.data("gravity-y")),m=50,x=new createjs.Stage(s),c=["#828b20","#b0ac31","#cbc53d","#fad779","#f9e4ad","#faf2db","#563512","#9b4a0b","#d36600","#fe8a00","#f9a71f"],a=[],o=[],k=!1,s.addArt=function(){var e,r,t,o,d,i,l,h,f,u;for(e=new createjs.Shape,e.radius=Math.random()*(p-v)+v,t=o=l=m;0>=l?0>=o:o>=0;t=0>=l?++o:--o)e.graphics.beginFill(c[Math.random()*c.length|0]).drawCircle(0,0,e.radius*t/m);for(e.x=s.width*(.5+.4*Math.random()-.2),e.y=(null!=(h=null!=(f=a[a.length-1])?f.y:void 0)?h:0)+e.radius,e.mass=n-a.length,e.mass<=0&&(e.mass=1),e.velocity=new createjs.Point(0,0),e.force=new createjs.Point(0,0),e.snapToPixel=!0,e.cache(-e.radius,-e.radius,2*e.radius,2*e.radius),u=a.slice(Math.max(0,a.length-n)),i=0,d=u.length;d>i;i++)r=u[i],s.addBondFor(e,r);return a.push(e),x.addChild(e),e},s.toggleShowBonds=function(){var a,e,r,t;if(k=!k,!k){for(t=[],e=0,r=o.length;r>e;e++)a=o[e],t.push(a.shape.graphics.clear());return t}},s.addBondFor=function(a,e){var r;return r=new createjs.Shape,o.push({arts:[a,e],length:(a.radius+e.radius)*t,shape:r}),x.addChild(r)},h=u=0,w=e;w>=0?w>u:u>w;h=w>=0?++u:--u)s.addArt();createjs.Ticker.timingMode=createjs.Ticker.RAF,j.push(createjs.Ticker.addEventListener("tick",function(e){var t,n,s,c,d,h,f,u,g,p,v,y,w,j,m,S,$;for(y=0,u=o.length;u>y;y++)c=o[y],n=c.arts[0],s=c.arts[1],$=s.position().subtract(n.position()),f=$.length(),d=$.scale(1/f),h=d.scale(-b/f*f+(f-c.length)*r),n.force=n.force.add(h),s.force=s.force.add(h.scale(-1));for(w=0,g=a.length;g>w;w++)t=a[w],t.force=t.force.add(l),t.velocity=t.velocity.add(t.force).scale(1/t.mass*i),t.force=new createjs.Point(0,0);for(j=0,p=a.length;p>j;j++)t=a[j],S=t.position().add(t.velocity),t.x=S.x,t.y=S.y;if(k)for(m=0,v=o.length;v>m;m++)c=o[m],c.shape.graphics.clear().beginStroke("#333").moveTo(c.arts[0].x,c.arts[0].y).lineTo(c.arts[1].x,c.arts[1].y).endStroke();return x.update(e)}))}return j})}).call(this);