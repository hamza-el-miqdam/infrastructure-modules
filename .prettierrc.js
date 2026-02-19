module.exports = {
  // Standard Prettier options
  printWidth: 80,
  tabWidth: 2,
  useTabs: false,
  semi: true,
  singleQuote: true,
  trailingComma: "es5",
  bracketSpacing: true,
  bracketSameLine: false,
  arrowParens: "always",

  // Plugin-specific options for Terraform can be added if needed,
  // but the default behavior of using `terraform fmt` is usually sufficient.

  // This section is important for making sure the plugin is recognized
  plugins: [require("prettier-plugin-terraform-formatter"), require("prettier-plugin-sh")],

  // Override for Terraform files to ensure the plugin is used
  overrides: [
    {
      files: "*.tf",
      options: {
        // The parser is automatically inferred by the plugin
      },
    },
    {
      files: "*.tfvars",
      options: {
        // The parser is automatically inferred by the plugin
      },
    },
    {
      files: "*.sh",
      options: {
        // The parser is automatically inferred by the plugin
      },
    },
  ],
};
