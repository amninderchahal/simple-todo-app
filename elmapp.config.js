module.exports = {
    configureWebpack: (config, env) => {

        // add regeneratorRuntime polyfill
        config.entry.unshift('regenerator-runtime/runtime');

        // We need to ignore .ts files in url-loader
        const urlLoaderRule = config.module.rules.find(rule => rule.loader && rule.loader.includes('url-loader'));
        urlLoaderRule.exclude.push(/\.ts?$/);

        // Add additional rules
        config.module.rules.push(
            { test: /\.ts?$/, loader: "ts-loader" },
            {
                test: /\.s[ac]ss$/i,
                use: [
                    "style-loader",
                    "css-loader",
                    "postcss-loader",
                    {
                        loader: "sass-loader",
                        options: {
                            implementation: require("sass"),
                        },
                    },
                ]
            }
        );

        return config;
    }
}