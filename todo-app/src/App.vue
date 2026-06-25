<script setup>
import { ref, computed } from 'vue'

const newTask = ref('')
const tasks = ref([])

const pendingCount = computed(() => tasks.value.filter(t => !t.done).length)

function addTask() {
  const text = newTask.value.trim()
  if (!text) return
  tasks.value.push({ id: Date.now(), text, done: false })
  newTask.value = ''
}

function removeTask(id) {
  tasks.value = tasks.value.filter(t => t.id !== id)
}

function clearCompleted() {
  tasks.value = tasks.value.filter(t => !t.done)
}
</script>

<template>
  <div class="app">
    <h1>To-Do List</h1>

    <form class="add-form" @submit.prevent="addTask">
      <input
        v-model="newTask"
        type="text"
        placeholder="Add a new task..."
        class="task-input"
      />
      <button type="submit" class="btn btn-add">Add</button>
    </form>

    <p class="summary" v-if="tasks.length">
      {{ pendingCount }} task{{ pendingCount !== 1 ? 's' : '' }} remaining
    </p>

    <ul class="task-list" v-if="tasks.length">
      <li
        v-for="task in tasks"
        :key="task.id"
        :class="{ done: task.done }"
        class="task-item"
      >
        <input type="checkbox" v-model="task.done" class="task-check" />
        <span class="task-text">{{ task.text }}</span>
        <button class="btn btn-remove" @click="removeTask(task.id)">✕</button>
      </li>
    </ul>

    <p class="empty" v-else>No tasks yet. Add one above!</p>

    <button
      v-if="tasks.some(t => t.done)"
      class="btn btn-clear"
      @click="clearCompleted"
    >
      Clear completed
    </button>
  </div>
</template>

<style scoped>
.app {
  max-width: 540px;
  margin: 60px auto;
  padding: 2rem;
  background: #1e1e2e;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
  font-family: 'Segoe UI', sans-serif;
  color: #cdd6f4;
}

h1 {
  text-align: center;
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
  color: #89b4fa;
}

.add-form {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.task-input {
  flex: 1;
  padding: 0.6rem 0.9rem;
  border-radius: 8px;
  border: 1px solid #45475a;
  background: #313244;
  color: #cdd6f4;
  font-size: 1rem;
  outline: none;
}

.task-input:focus {
  border-color: #89b4fa;
}

.btn {
  padding: 0.6rem 1.1rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.95rem;
  transition: opacity 0.2s;
}

.btn:hover { opacity: 0.85; }

.btn-add {
  background: #89b4fa;
  color: #1e1e2e;
  font-weight: 600;
}

.btn-remove {
  background: #f38ba8;
  color: #1e1e2e;
  padding: 0.3rem 0.65rem;
  font-size: 0.85rem;
}

.btn-clear {
  margin-top: 1rem;
  width: 100%;
  background: #45475a;
  color: #cdd6f4;
}

.summary {
  font-size: 0.9rem;
  color: #a6adc8;
  margin-bottom: 0.75rem;
}

.task-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.task-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: #313244;
  padding: 0.65rem 0.9rem;
  border-radius: 8px;
}

.task-item.done .task-text {
  text-decoration: line-through;
  color: #585b70;
}

.task-check {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: #a6e3a1;
}

.task-text {
  flex: 1;
  font-size: 1rem;
}

.empty {
  text-align: center;
  color: #585b70;
  font-style: italic;
}
</style>
