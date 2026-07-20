String normalizeTr(String s) {
  const map = {
    'ı': 'i',
    'İ': 'i',
    'ş': 's',
    'Ş': 's',
    'ğ': 'g',
    'Ğ': 'g',
    'ü': 'u',
    'Ü': 'u',
    'ö': 'o',
    'Ö': 'o',
    'ç': 'c',
    'Ç': 'c',
    'â': 'a',
    'Â': 'a',
  };
  var out = s;
  map.forEach((k, v) => out = out.replaceAll(k, v));
  return out.toLowerCase();
}
