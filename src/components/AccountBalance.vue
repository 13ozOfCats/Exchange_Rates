<script>
export default {
  name: "AccountBalance",
  props: {
    wallet: {
      type: Array,
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
    <table class="table">
      <tbody class="table__tbody">
        <tr v-for="(value, key) in wallet" :key="key" class="table__row">
          <td class="table__rate">
            {{ key }}
          </td>
          <td class="table__val">
            {{ value }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
