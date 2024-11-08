#!/bin/bash
# .devcontainer/setup.sh

# Make script exit on first error
set -e

# Check if the folder react-gen-ui exists, delete if it does
if [ -d "react-gen-ui" ]; then
    rm -rf react-gen-ui
fi

# Create Vite project with React TypeScript template
npm install -g create-vite@latest --yes
create-vite react-gen-ui --template react-ts --yes

cd react-gen-ui

# Install necessary dependencies
npm install --yes
npm install -D tailwindcss postcss autoprefixer --yes
npm install lucide-react --yes
npm install class-variance-authority clsx tailwind-merge --yes
npm install @radix-ui/react-slot --yes
npm install -D @shadcn/ui --yes
npm install -D @types/node --yes

# Initialize Tailwind CSS
npx tailwindcss init -p

# Use sed to add Tailwind imports to the top of index.css
sed -i '1i @tailwind base;\n@tailwind components;\n@tailwind utilities;\n' src/index.css

# Update content line in tailwind.config.js
sed -i '/content: \[/,/],/c\  content: [\n    "./index.html",\n    "./src/**/*.{ts,tsx,js,jsx}",\n  ],' tailwind.config.js

# Override tsconfig.json
cat > tsconfig.json << 'EOL'
{
  "files": [],
  "references": [
    {
      "path": "./tsconfig.app.json"
    },
    {
      "path": "./tsconfig.node.json"
    }
  ],
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
EOL

# Override tsconfig.app.json
cat > tsconfig.app.json << 'EOL'
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": [
        "./src/*"
      ]
    },
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "Bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedSideEffectImports": true
  },
  "include": ["src"]
}
EOL

# Override vite.config.ts
cat > vite.config.ts << 'EOL'
import path from "path"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
EOL


# Make the setup script executable
chmod +x .devcontainer/setup.sh

echo "Setup completed successfully! You can now start adding shadcn/ui components using: npx shadcn-ui@latest add <component-name>"
