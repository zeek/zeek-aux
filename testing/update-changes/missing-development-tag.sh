# @TEST-DOC: A missing development tag fails quickly with an actionable diagnostic.
#
# @TEST-EXEC: bash %INPUT
# @TEST-EXEC-FAIL: update-changes -c >output 2>&1
# @TEST-EXEC: grep -Fxq 'Cannot determine revision for version 2.0.0-dev.1: missing base tag v2.0.0-dev.' output
# @TEST-EXEC: test "$(wc -l <output)" -eq 1

git init .
echo "Hello" >README
git add README
git commit -m 'init'
git tag v1.0.0

echo '2.0.0-dev.1 | 2026-09-15 00:00:00 +0000' >CHANGES
git add CHANGES
git commit -m 'start development'
