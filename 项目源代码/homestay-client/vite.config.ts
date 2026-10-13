import { UserConfig, ConfigEnv } from 'vite';
import { createVitePlugins } from './build/vite/plugins';
import { resolve } from 'path';
import { VITE_PORT } from './build/constant';

function pathResolve(dir: string) {
  return resolve(process.cwd(), '.', dir);
}

// https://vitejs.dev/config/
export default ({ command }: ConfigEnv): UserConfig => {
  const isBuild = command === 'build';
  let base: string;
  if (command === 'build') {
    base = '/';
  } else {
    base = '/';
  }
  return {
    base,
    publicDir: "public", //静态资源服务的文件夹
    resolve: {
      alias: [
        {
          find: 'vue-i18n',
          replacement: 'vue-i18n/dist/vue-i18n.cjs.js',
        },
        // 别名 /@/xxxx => src/xxxx
        {
          find: '/@',
          replacement: pathResolve('src') + '/',
        },
      ],
    },
    // plugins
    plugins: createVitePlugins(isBuild),

    // css
    css: {},

    // build - 性能优化
    build: {
      outDir: 'dist',
      assetsDir: 'assets',
      chunkSizeWarningLimit: 1500,
      rollupOptions: {
        output: {
          chunkFileNames: 'static/js/[name]-[hash].js',
          entryFileNames: 'static/js/[name]-[hash].js',
          assetFileNames: 'static/[ext]/[name]-[hash].[ext]',
          // 性能优化：代码分割
          manualChunks: {
            // Vue 全家桶单独打包
            'vue-vendor': ['vue', 'vue-router', 'pinia'],
            // Ant Design Vue 单独打包
            'ant-design': ['ant-design-vue', '@ant-design/icons-vue'],
            // ECharts 单独打包
            'echarts': ['echarts'],
            // 工具库单独打包
            'utils': ['axios', 'jsencrypt']
          }
        }
      },
      // 性能优化：压缩配置
      minify: 'terser',
      terserOptions: {
        compress: {
          drop_console: isBuild,
          drop_debugger: isBuild
        }
      }
    },

    // server
    server: {
      hmr: { overlay: false }, // 禁用或配置 HMR 连接 设置 server.hmr.overlay 为 false 可以禁用服务器错误遮罩层
      // 服务配置
      port: VITE_PORT, // 类型： number 指定服务器端口;
      open: false, // 类型： boolean | string在服务器启动时自动在浏览器中打开应用程序；
      cors: true, // 类型： boolean | CorsOptions 为开发服务器配置 CORS。默认启用并允许任何源
      host: '0.0.0.0', // IP配置，支持从IP启动
      https: false, // 禁用https
      allowedHosts: 'all', // 允许所有主机访问（支持内网穿透）
      // proxy
      proxy: {
        '/api': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
        '/profile': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
        '/register': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
        '/login': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
        '/logout': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
        '/captchaImage': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
        '/getInfo': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
        '/system': {
          target: 'http://127.0.0.1:8083',
          changeOrigin: true,
        },
      },
    },
  };
};
