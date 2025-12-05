# Tech Stack

<!--
AGENT INSTRUCTIONS:
- Reference this when implementing ANY feature
- Keep updated as stack evolves
- Include version numbers where relevant
- After updating, run /sync-project to update Linear project description
-->

## Core Technologies

### Frontend
- **Framework**: [e.g., Next.js 14, React 18, Vue 3]
- **Language**: [e.g., TypeScript 5.x]
- **Styling**: [e.g., Tailwind CSS, CSS Modules, styled-components]
- **State Management**: [e.g., Zustand, Redux, React Query]

### Backend
- **Runtime**: [e.g., Node.js, Deno, Bun]
- **Framework**: [e.g., Express, Fastify, Hono]
- **Database**: [e.g., PostgreSQL, MongoDB, Convex]
- **ORM/Query**: [e.g., Prisma, Drizzle, native]

### Infrastructure
- **Hosting**: [e.g., Vercel, AWS, Railway]
- **CI/CD**: [e.g., GitHub Actions, CircleCI]
- **Monitoring**: [e.g., Sentry, DataDog]

---

## Architecture Patterns

### Project Structure
```
src/
├── app/           # [Describe: e.g., Next.js app router pages]
├── components/    # [Describe: e.g., Shared UI components]
├── lib/           # [Describe: e.g., Utilities and helpers]
├── hooks/         # [Describe: e.g., Custom React hooks]
└── types/         # [Describe: e.g., TypeScript type definitions]
```

### Data Flow
[Describe how data flows through the application]

### API Design
[REST/GraphQL/tRPC - describe patterns used]

---

## Key Dependencies

### Production Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| [package] | [version] | [what it does] |

### Development Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| [package] | [version] | [what it does] |

---

## Environment Configuration

### Required Environment Variables
```bash
# API Keys
API_KEY=           # [Description]

# Database
DATABASE_URL=      # [Description]

# Third-party Services
SERVICE_KEY=       # [Description]
```

### Local Development
```bash
# How to run locally
npm install
npm run dev
```

---

## Integration Points

### External Services
- **[Service Name]**: [What it's used for, API docs link]
- **[Service Name]**: [What it's used for, API docs link]

### Internal APIs
- **[API Name]**: [Endpoint pattern, purpose]

---

## Performance Considerations
- [Key performance pattern or constraint]
- [Caching strategy]
- [Rate limits to be aware of]

---

## Security Notes
- [Authentication method]
- [Authorization pattern]
- [Data handling requirements]

---

*Last Updated: YYYY-MM-DD*

