(function(){$(function(){var e,t,n,r,a,o,i,s,u,d,c,h,l,w,g,y,D,f,p,B,x,m,b,C,v,S,A,F,G,M,T,j,k,J,L,O,P,_,E;if(D=$("canvas#tumtum")[0]){for(n=10,J=.1,k=.35,F=!1,f=!1,P=new createjs.Stage(D),r=new createjs.Container,G=new createjs.Container,P.addChild(r),g=[],l=Box2D.Common.Math.b2Vec2,i=Box2D.Dynamics.b2BodyDef,o=Box2D.Dynamics.b2Body,d=Box2D.Dynamics.b2FixtureDef,w=Box2D.Dynamics.b2World,h=Box2D.Collision.Shapes.b2PolygonShape,s=Box2D.Collision.Shapes.b2CircleShape,u=Box2D.Dynamics.b2DebugDraw,a=Box2D.Collision.b2AABB,c=Box2D.Dynamics.Joints.b2MouseJointDef,p=$(D),m=new l(p.data("gravity-x"),p.data("gravity-y")),E=new w(m,!0),t=D.width,_=D.width/t,S=D.height/t,B=new d,B.density=1,e=$("#arts-count"),j=new l,T=null,y=function(){var e,t,n,r,a,s;return e=new i,e.type=o.b2_staticBody,y=E.CreateBody(e),r=.1,s=100*S,a=new d,a.shape=new h,a.shape.SetAsOrientedBox(_/2,r,new l(_/2,-r),0),t=new d,t.shape=new h,t.shape.SetAsOrientedBox(r,s,new l(-r,0),0),n=new d,n.shape=new h,n.shape.SetAsOrientedBox(r,s,new l(_+r,0),0),y.CreateFixture(a),y.CreateFixture(t),y.CreateFixture(n),y}(),b=function(e){var n,r,a,o;a=e.stageX,o=e.stageY,j.Set(a/t,o/t),r=x(),r&&(n=new c,n.bodyA=y,n.bodyB=r,n.target=j,n.collideConnected=!0,n.maxForce=1e3*r.GetMass(),n.dampingRatio=0,T=E.CreateJoint(n),r.SetAwake(!0))},C=function(e){var n,r;n=e.stageX,r=e.stageY,j.Set(n/t,r/t),T&&T.SetTarget(j)},v=function(e){this.onMouseMove=this.onMouseUp=null,T&&(E.DestroyJoint(T),T=!1)},x=function(e){var t,n,r;return n=null,t=new a,r=function(t){var r,a;return a=t.GetShape(),(t.GetBody().GetType()!==o.b2_staticBody||e)&&(r=a.TestPoint(t.GetBody().GetTransform(),j))?(n=t.GetBody(),!1):!0},t.lowerBound.Set(j.x-.001,j.y-.001),t.upperBound.Set(j.x+.001,j.y+.001),E.QueryAABB(r,t),n},D.showArtsCount=function(){return e.text(g.length)},D.addActors=function(e){var t,n;return n=g.slice().sort(function(e,t){return-(e.radius-t.radius)}),t=n.indexOf(e),r.addChildAt(e.actors[0],t),G.addChildAt(e.actors[1],t)},D.addArt=function(){var e,n,r,a,u,d;return d=Math.random()*(k-J)+J,a=new i,a.type=o.b2_dynamicBody,B.shape=new s(.8*d),a.position.Set(_*(.1+.8*Math.random()),S+Math.random()),r=E.CreateBody(a),r.CreateFixture(B),u=g.push(r),r.radius=d,e=new ArtImage(d*t,u),e.addEventListener("mousedown",b),e.addEventListener("pressmove",C),e.addEventListener("pressup",v),n=new Baumkuchen(d*t),r.actors=[e,n],D.addActors(r),D.showArtsCount()},D.addArt10=function(){var e,t,n;for(n=[],e=t=1;10>=t;e=++t)n.push(D.addArt());return n},D.toggleImages=function(){return F=!F,F?(r.remove(),P.addChildAt(G,0)):(P.addChildAt(r,0),G.remove()),F},D.toggleDebug=function(){return f=!f,f&&!this.debugDraw&&(this.debugDraw=new u,this.debugDraw.SetSprite(D.getContext("2d")),this.debugDraw.SetDrawScale(t),this.debugDraw.SetFillAlpha(.3),this.debugDraw.SetLineThickness(1),this.debugDraw.SetFlags(u.e_shapeBit|u.e_jointBit),E.SetDebugDraw(this.debugDraw)),f},D.reset=function(){var e,t,n;for(t=0,n=g.length;n>t;t++)e=g[t],E.DestroyBody(e),r.removeChild(e.actors[0]),G.removeChild(e.actors[1]);return g=[],D.showArtsCount(),!1},D.dump=function(){var e,t,n;return n=function(){var t,n,r;for(r=[],t=0,n=g.length;n>t;t++)e=g[t],r.push({x:e.GetPosition().x,y:e.GetPosition().y,radius:e.radius});return r}(),t={count:n.length,elements:n},$("#output").text(JSON.stringify(t))},createjs.Ticker.timingMode=createjs.Ticker.RAF,createjs.Ticker.addEventListener("tick",function(e){var n,r,a,o,i,s,u,d;if(E.Step(1/60,3,3),E.ClearForces(),f)return E.DrawDebugData();for(a=0,i=g.length;i>a;a++)if(r=g[a],u=r.GetPosition(),u&&null!=u.x&&null!=u.y)for(d=r.actors,o=0,s=d.length;s>o;o++)n=d[o],n.x=u.x*t,n.y=u.y*t;return P.update(e)}),O=[],A=M=0,L=n;L>=0?L>M:M>L;A=L>=0?++M:--M)O.push(D.addArt());return O}})}).call(this);