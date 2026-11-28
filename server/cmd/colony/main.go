package main

import (
	"colony.world/server/internal/auth"
	"colony.world/server/internal/transport"
	"context"
	"errors"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"
	"time"
)

func main() {
	addr := os.Getenv("CW_ADDR")
	if addr == "" {
		addr = "127.0.0.1:3000"
	}
	host, _, err := net.SplitHostPort(addr)
	if err != nil || (host != "127.0.0.1" && host != "localhost" && host != "::1") {
		log.Fatal("P0.7 only supports loopback CW_ADDR")
	}
	dir := os.Getenv("CW_DATA_DIR")
	if dir == "" {
		base, e := os.UserConfigDir()
		if e != nil {
			log.Fatal(e)
		}
		dir = filepath.Join(base, "ColonyWorld", "dev")
	}
	service, e := auth.Open(dir)
	if e != nil {
		log.Fatal(e)
	}
	s := &http.Server{Addr: addr, Handler: transport.NewHandler(service), ReadHeaderTimeout: 5 * time.Second, ReadTimeout: 10 * time.Second, WriteTimeout: 10 * time.Second, IdleTimeout: 30 * time.Second, MaxHeaderBytes: 16384}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	go func() {
		<-ctx.Done()
		c, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		_ = s.Shutdown(c)
	}()
	log.Printf("Colony World %s listening on %s (local development account store)", transport.Phase, addr)
	if err := s.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Fatal(err)
	}
}
