# MVP


#### 简述
1. MVP模式把MVC模式中的Controller换成了Presenter，View不再依赖Model层，其他依赖关系和MVC一致。
2. 用户对View的操作都会从View交移给Presenter。Presenter同样的会执行相应的业务逻辑，并且对Model进行相应的操作；而这时候Model通过观察者模式把自己变更的消息传给Presenter, Presenter获取到Model变更的消息以后通过View提供的接口更新界面。
3. View不再负责同步的逻辑，而是由Presenter负责。Presenter中既有业务逻辑也有同步逻辑。View需要提供操作界面的接口给Presenter进行调用。
4. 便于测试，View也可以进行组件化。不过Presenter中除了业务逻辑以外，还有大量的View->Model, Model->View的手动同步逻辑，造成Presenter比较笨重，维护起来比较困难。



