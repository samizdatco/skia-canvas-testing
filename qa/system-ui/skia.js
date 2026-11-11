// which font each candidate name resolves to through skia-canvas, compared with SFNS.ttf loaded by path
// usage: node skia.js <lib-dir>
const path = require('path'), os = require('os'),
      {Canvas, FontLibrary} = require(path.resolve(process.argv[2]));
const sample = 'Hamburgefonstiv 0123456789'
const ctx = new Canvas(10, 10).getContext('2d');
const probe = (font) => {
  ctx.font = font
  let m = ctx.measureText(sample), runs = m.lines.flatMap(l => l.runs)
  return `${runs.map(r => r.family).join('+')} width=${m.width.toFixed(2)}`
}
console.log('darwin', os.release())
FontLibrary.use('SF by path', ['/System/Library/Fonts/SFNS.ttf'])
console.log('reference'.padEnd(26), probe('20px "SF by path"'))
for (let name of ['system-ui', '".AppleSystemUIFont"', '"System Font"', '"SF Pro"', '"SF Pro Text"', '"Helvetica Neue"']){
  let fam = name.replace(/"/g, '')
  console.log(name.padEnd(26), probe(`20px ${name}`), ' has:', FontLibrary.has(fam), ' listed:', FontLibrary.families.includes(fam))
}
console.log('default (unknown family)'.padEnd(26), probe('20px "No Such Font"'))
// weights & italics should pick different instances of the hidden family
for (let style of ['100', '400', '700', '900', 'italic 400', 'italic 700']){
  console.log(`${style} .AppleSystemUIFont`.padEnd(26), probe(`${style} 20px ".AppleSystemUIFont"`))
}
