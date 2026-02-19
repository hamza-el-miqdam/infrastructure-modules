const path = require('path');

module.exports = {
  '*.{tf,tfvars}': (filenames) => {
    const relativeFiles = filenames.map((f) => path.relative(process.cwd(), f));

    const fmtCmd = `terraform fmt ${relativeFiles.join(' ')}`;

    const tflintArgs = relativeFiles.map((f) => `--filter=${f}`).join(' ');
    const lintCmd = `tflint ${tflintArgs}`;

    return [fmtCmd, lintCmd];
  },
  '*.md': 'prettier -w',
  '*.{json,yaml,yml}': 'prettier -w',
  '*.sh': 'prettier -w',
};
