import argparse
import http.server
import os
import socketserver
from urllib.parse import unquote, urlparse


class SpaRequestHandler(http.server.SimpleHTTPRequestHandler):
    # Serve index.html for unknown routes so Vue Router history mode works.
    def do_GET(self):
        parsed = urlparse(self.path)
        req_path = unquote(parsed.path or "/")
        fs_path = self.translate_path(req_path)

        if os.path.exists(fs_path):
            return super().do_GET()

        self.path = "/index.html"
        return super().do_GET()


def main():
    parser = argparse.ArgumentParser(description="Static SPA server")
    parser.add_argument("--port", type=int, default=3000)
    parser.add_argument("--host", default="0.0.0.0")
    args = parser.parse_args()

    with socketserver.TCPServer((args.host, args.port), SpaRequestHandler) as httpd:
        print(f"Serving SPA at http://{args.host}:{args.port}")
        httpd.serve_forever()


if __name__ == "__main__":
    main()
