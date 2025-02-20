#lang forge/froglet

sig Light {
    on: Bool,
    neighbors: set Light
}