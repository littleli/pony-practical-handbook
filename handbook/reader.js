'use strict';
const jobs = {
  ref: ['ref', 'Keep the mutable notebook inside its actor. Local aliases may read and write it. See stage 01.'],
  box: ['box', 'Accept a readable view. A local writer may still change the object. Do not send this view to another actor. See stage 03.'],
  val: ['val', 'Publish an immutable result. Retain it and send it repeatedly. Build a snapshot or give up a unique writer. See stage 04.'],
  iso: ['iso', 'Transfer mutable ownership. Move a named parcel with consume; the sender loses access through that binding. See stage 05.'],
  trn: ['trn', 'Keep one writer and allow local box readers, then consume val to freeze. See stage 07.'],
  tag: ['tag', 'Keep an actor address and send behaviors. This reference does not allow reading the actor’s fields. See stage 05.']
};
const selector = document.getElementById('cap-job');
const answer = document.getElementById('cap-answer');
function explainJob() {
  const [cap, explanation] = jobs[selector.value];
  answer.replaceChildren();
  const code = document.createElement('code'); code.textContent = cap;
  answer.append(code, document.createTextNode(' — ' + explanation));
}
selector.addEventListener('change', explainJob); explainJob();
const links = [...document.querySelectorAll('nav a')];
function markCurrent(id) {
  links.forEach(link => {
    if (link.hash === '#' + id) link.setAttribute('aria-current', 'location');
    else link.removeAttribute('aria-current');
  });
}
const observer = new IntersectionObserver(entries => {
  for (const entry of entries) if (entry.isIntersecting) markCurrent(entry.target.id);
}, {rootMargin: '-5% 0px -80% 0px', threshold: 0});
document.querySelectorAll('section').forEach(section => observer.observe(section));
links.forEach(link => link.addEventListener('click', () => markCurrent(link.hash.slice(1))));
let statusTimer;
document.querySelectorAll('.copy').forEach(button => {
  button.addEventListener('click', async () => {
    const code = button.closest('figure').querySelector('pre code').textContent;
    const status = document.getElementById('copy-status');
    try {await navigator.clipboard.writeText(code); status.textContent = 'Code copied';}
    catch {status.textContent = 'Select the code and copy with your keyboard.';}
    clearTimeout(statusTimer);statusTimer = setTimeout(() => {status.textContent = '';}, 3000);
  });
});
document.getElementById('print').addEventListener('click', () => window.print());
let previouslyClosed = [];
window.addEventListener('beforeprint', () => {
  previouslyClosed = [...document.querySelectorAll('details:not([open])')];
  previouslyClosed.forEach(detail => {detail.open = true;});
});
window.addEventListener('afterprint', () => {
  previouslyClosed.forEach(detail => {detail.open = false;});
});
