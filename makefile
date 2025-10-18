postgres:
	docker run --name postgres17 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=112233 -d postgres:17-alpine

createdb:
	docker exec -it postgres17 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres17 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgres://root:112233@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgres://root:112233@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

cleantest:
	go clean -testcache	

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/ColinTing/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test cleantest server mock