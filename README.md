# Codebase Knowledge Builder

Bộ công cụ hỗ trợ Codex xây dựng và duy trì kiến thức có dẫn chứng về các project trong một thư mục mã nguồn. Repository này gồm các skill tái sử dụng và một custom agent dùng CodeGraph để lập chỉ mục, phân tích kiến trúc và cập nhật durable knowledge.

## Thành phần

- `skills/`: các skill theo nhóm `knowledge`, `planning`, `development`, `testing`, `verification`, `review`, `risk-review`, `workflow` và `core`.
- `agents/codebase-knowledge-builder/`: tài liệu, schema, playbook truy vấn CodeGraph và script chuẩn bị project.
- `codebase-knowledge-builder.toml`: cấu hình custom agent `codebase_knowledge_builder`.

## Yêu cầu

- Codex với quyền đọc thư mục source project.
- CodeGraph được cài và có sẵn trên `PATH`.
- Các project cần quét nằm trực tiếp trong `$HOME/Documents/myData/sourceCode` hoặc đường dẫn được đặt qua `CODEBASE_SOURCE_ROOT`.

### Cài CodeGraph

CodeGraph là công cụ bên ngoài repository này. Xem tài liệu và mã nguồn chính thức tại [github.com/colbymchenry/codegraph](https://github.com/colbymchenry/codegraph). Hướng dẫn cài đặt nhanh cũng có tại [CodeGraph Quickstart](https://colbymchenry.github.io/codegraph/getting-started/quickstart/).

Trên macOS/Linux, cài bằng installer chính thức:

```bash
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
```

Hoặc nếu đã có Node.js:

```bash
npm install -g @colbymchenry/codegraph
```

Mở terminal mới rồi kiểm tra:

```bash
codegraph --version
```

Kết nối CodeGraph với Codex và tạo index cho từng project:

```bash
codegraph install
cd /path/to/your-project
codegraph init
```

`codegraph init` tạo thư mục `.codegraph/` cục bộ trong project. Không cần commit thư mục này lên repository.

## Cài đặt trên máy mới

Repository này chứa skill, custom agent và cấu hình; CodeGraph là công cụ runtime cần cài riêng trên từng máy. Sau khi cài CodeGraph, clone repository và cài agent vào thư mục Codex:

```bash
git clone git@github.com:HaHust/codebase.git
cd codebase

mkdir -p ~/.codex/agents
cp -R agents/codebase-knowledge-builder ~/.codex/agents/
cp agents/codebase-knowledge-builder.toml ~/.codex/agents/
```

Trước khi sử dụng, đặt các biến môi trường sau nếu máy mới dùng thư mục khác:

```text
CODEBASE_SOURCE_ROOT="$HOME/Documents/myData/sourceCode"
CODEBASE_KNOWLEDGE_ROOT="$HOME/.codex/projects"
CODEGRAPH_BIN="codegraph"
```

Nếu chưa cài CodeGraph, có thể đọc và sử dụng các skill thủ công, nhưng custom agent và `prepare-projects.sh` sẽ không chạy được.

## Sử dụng

Đặt thư mục agent vào `~/.codex/agents/`:

```bash
cp -R agents/codebase-knowledge-builder ~/.codex/agents/
cp codebase-knowledge-builder.toml ~/.codex/agents/
```

Sau đó mở một phiên Codex mới và yêu cầu:

```text
Use codebase_knowledge_builder to scan all projects and build or refresh their durable knowledge.
```

Hoặc yêu cầu quét một project cụ thể:

```text
Use codebase_knowledge_builder to incrementally refresh the order project.
```

Script chuẩn bị có thể được chạy trực tiếp:

```bash
codebase-knowledge-builder/prepare-projects.sh list
codebase-knowledge-builder/prepare-projects.sh prepare-all
codebase-knowledge-builder/prepare-projects.sh prepare <project-name>
codebase-knowledge-builder/prepare-projects.sh status-all
```

## Kết quả

Với mỗi project, agent tạo durable knowledge tại `~/.codex/projects/<project-name>/`, gồm repository, technology stack, architecture, API, database, business flow/rule, conventions, patterns, reusable components, coding behaviors và manifest theo dõi lần quét.

Agent chỉ đọc và phân tích source project; không chỉnh sửa application code, test hoặc migration của project được quét.

## Tài liệu tham khảo

- [Hướng dẫn custom agent](agents/codebase-knowledge-builder/README.md)
- [Knowledge schema](agents/codebase-knowledge-builder/references/knowledge-schema.md)
- [CodeGraph query playbook](agents/codebase-knowledge-builder/references/codegraph-query-playbook.md)
- [Skill registry](skills/skill-registry.md)
