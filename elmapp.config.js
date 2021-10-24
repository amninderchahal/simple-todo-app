module.exports = {
    configureWebpack: (config, env) => {

        config.module.rules.push({
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
            ],
        });

        return config;
    }
}