(function () {
  const wrapper = document.querySelector('.crosshair-wrapper');
  const root = document.documentElement;
  let isVisible = false;

  function show() {
    if (wrapper) {
      if (isVisible) return;
      requestAnimationFrame(() => { wrapper.style.opacity = '1'; });
      isVisible = true;
    }
  }

  function hide() {
    if (wrapper) {
      if (!isVisible) return;
      wrapper.style.opacity = '0';
      isVisible = false;
    }
  }

  function setColor(hex) {
    if (!hex) return;
    root.style.setProperty('--crosshair-color', hex);
  }

  function setSize(px) {
    if (!px) return;
    const size = Number(px);
    if (Number.isNaN(size)) return;
    const clamped = Math.max(1, Math.min(10, size));
    const dot = document.querySelector('.crosshair-dot');
    if (dot) {
      dot.style.width = clamped + 'px';
      dot.style.height = clamped + 'px';
      // Keep centered via transform: translate(-50%, -50%) so no manual margins.
    }
  }

  window.addEventListener('message', (event) => {
    const data = event.data || {};
    switch (data.action || data.display) {
      case 'show':
      case 'crosshairShow':
      case 'reticleShow':
        show();
        break;
      case 'hide':
      case 'crosshairHide':
      case 'reticleHide':
        hide();
        break;
      case 'color':
      case 'reticleColor':
        setColor(data.color);
        break;
      case 'size':
        setSize(data.size);
        break;
    }
  });
})();
