(() => {
  const qs=(s,r=document)=>r.querySelector(s);
  const qsa=(s,r=document)=>[...r.querySelectorAll(s)];

  const header=qs('.site-header');
  const menu=qs('.menu-button');
  const links=qs('.nav-links');
  const syncHeader=()=>header?.classList.toggle('scrolled',scrollY>20);
  syncHeader();
  addEventListener('scroll',syncHeader,{passive:true});

  menu?.addEventListener('click',()=>{
    const open=links?.classList.toggle('open');
    menu.setAttribute('aria-expanded',String(!!open));
  });
  qsa('.nav-links a').forEach(a=>a.addEventListener('click',()=>{
    links?.classList.remove('open');
    menu?.setAttribute('aria-expanded','false');
  }));

  const io=new IntersectionObserver(entries=>entries.forEach(entry=>{
    if(entry.isIntersecting){entry.target.classList.add('in');io.unobserve(entry.target)}
  }),{threshold:.08,rootMargin:'0px 0px -6%'});
  qsa('.reveal').forEach(el=>io.observe(el));

  const toast=qs('#downloadToast');
  qsa('[data-download-pending]').forEach(btn=>btn.addEventListener('click',e=>{
    e.preventDefault();
    if(!toast)return;
    toast.classList.add('show');
    clearTimeout(window.__ithynkToast);
    window.__ithynkToast=setTimeout(()=>toast.classList.remove('show'),4200);
  }));
})();
