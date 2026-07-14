# Codebase Knowledge Builder

Bộ công cụ hỗ trợ Codex xây dựng và duy trì kiến thức có dẫn chứng về các project trong một thư mục mã nguồn. Repository này gồm các skill tái sử dụng và một custom agent dùng CodeGraph để lập chỉ mục, phân tích kiến trúc và cập nhật durable knowledge.

## Thành phần

- `skills/`: các skill theo nhóm `knowledge`, `planning`, `development`, `testing`, `verification`, `review`, `risk-review`, `workflow` và `core`.
- `agents/codebase-knowledge-builder/`: tài liệu, schema, playbook truy vấn CodeGraph và script chuẩn bị project.
- `codebase-knowledge-builder.toml`: cấu hình custom agent `codebase_knowledge_builder`.

## Yêu cầu

- Codex với quyền đọc thư mục source project.
- CodeGraph được cài tại `/home/ha/.local/bin/codegraph`.
- Các project cần quét nằm trực tiếp trong `/home/ha/Documents/myData/sourceCode`.

## Cài đặt trên máy mới

Repository này chứa skill, custom agent và cấu hình; CodeGraph là công cụ runtime cần cài riêng trên từng máy. Sau khi cài CodeGraph, clone repository và cài agent vào thư mục Codex:

```bash
git clone git@github.com:HaHust/codebase.git
cd codebase

mkdir -p ~/.codex/agents
cp -R agents/codebase-knowledge-builder ~/.codex/agents/
cp agents/codebase-knowledge-builder.toml ~/.codex/agents/
```

Trước khi sử dụng, cập nhật các đường dẫn `/home/ha/...` trong `agents/codebase-knowledge-builder.toml` và `agents/codebase-knowledge-builder/prepare-projects.sh` để phù hợp với username và thư mục source trên máy mới. Mặc định, project cần quét nằm trực tiếp trong:

```text
<home-directory>/Documents/myData/sourceCode
```

Nếu chưa cài CodeGraph, có thể đọc và sử dụng các skill thủ công, nhưng custom agent và `prepare-projects.sh` sẽ không chạy được.

## Sử dụng

Đặt thư mục agent vào `~/.codex/agents/` (tương đương `/home/ha/.codex/agents/` trên Linux):

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

Với mỗi project, agent tạo durable knowledge tại `/home/ha/.codex/projects/<project-name>/`, gồm repository, technology stack, architecture, API, database, business flow/rule, conventions, patterns, reusable components, coding behaviors và manifest theo dõi lần quét.

Agent chỉ đọc và phân tích source project; không chỉnh sửa application code, test hoặc migration của project được quét.

## Tài liệu tham khảo

- [Hướng dẫn custom agent](agents/codebase-knowledge-builder/README.md)
- [Knowledge schema](agents/codebase-knowledge-builder/references/knowledge-schema.md)
- [CodeGraph query playbook](agents/codebase-knowledge-builder/references/codegraph-query-playbook.md)
- [Skill registry](skills/skill-registry.md)
