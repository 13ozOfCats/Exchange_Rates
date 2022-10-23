<script>
export default {
  name: "AccountBalance",
  props: {
    wallet: {
      type: Object,
      required: true
    }
  }
};
</script>

<template>
  <div class="account-balance">
    <div class="title">
      Баланс
    </div>
    <table>
      <tbody>
        <tr v-for="(value, key) in wallet" :key="key">
          <td>
            {{ key }}
          </td>
          <td>
            {{ value.toFixed(2) }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
