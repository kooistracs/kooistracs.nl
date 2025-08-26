default: dev

dev:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Building initial CSS..."
    just build-css
    echo "Starting TailwindCSS watcher..."
    tailwindcss -i ./sass/input.css -o ./static/style.css --watch &
    TAILWIND_PID=$!
    echo "Starting Zola dev server..."
    zola serve &
    ZOLA_PID=$!
    # Function to cleanup background processes
    cleanup() {
        echo "Cleaning up processes..."
        kill $TAILWIND_PID 2>/dev/null || true
        kill $ZOLA_PID 2>/dev/null || true
        exit 0
    }
    # Set trap to cleanup on script exit
    trap cleanup INT TERM
    echo "Development environment ready!"
    echo "   - Site: http://127.0.0.1:1111"
    echo "   - TailwindCSS: watching for changes"
    echo ""
    echo "Press Ctrl+C to stop"
    # Wait for background processes
    wait

build:
    echo "Building production site..."
    echo "Building and optimizing CSS..."
    just build-css --minify
    echo "Building Zola site..."
    zola build
    echo "Production build complete!"
    echo "   Output: ./public/"
    @if [ -f "./static/style.css" ]; then \
        CSS_SIZE=$(du -h "./static/style.css" | cut -f1); \
        echo "   CSS size: $CSS_SIZE"; \
    fi
    @if [ -d "./public" ]; then \
        SITE_SIZE=$(du -sh "./public" | cut -f1); \
        echo "   Site size: $SITE_SIZE"; \
    fi

build-css *FLAGS:
    tailwindcss -i ./sass/input.css -o ./static/style.css {{ FLAGS }}
    @if [ -f "./static/style.css" ]; then \
        CSS_SIZE=$(du -h "./static/style.css" | cut -f1); \
        echo "CSS built successfully! (Size: $CSS_SIZE)"; \
    fi

serve:
    @if [ ! -d "./public" ]; then \
        echo "No built site found. Run 'just build' first."; \
        exit 1; \
    fi
    echo "Serving built site..."
    zola serve

check:
    @echo "Checking setup..."
    @echo "  Checking required files..."
    @if [ ! -f "./sass/input.css" ]; then \
        echo "    sass/input.css not found"; \
        exit 1; \
    else \
        echo "    sass/input.css found"; \
    fi
    @if [ ! -f "./tailwind.config.js" ]; then \
        echo "    tailwind.config.js not found"; \
        exit 1; \
    else \
        echo "    tailwind.config.js found"; \
    fi
    @if [ ! -f "./config.toml" ]; then \
        echo "    config.toml not found"; \
        exit 1; \
    else \
        echo "    config.toml found"; \
    fi
    @echo "  Checking commands..."
    @which zola > /dev/null && echo "    zola available" || echo "    zola not found"
    @which tailwindcss > /dev/null && echo "    tailwindcss available" || echo "    tailwindcss not found"
    @echo "Setup looks good!"
