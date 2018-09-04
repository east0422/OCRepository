# 架构模式

## 1. MVC
* Controller和View都依赖Model层，Controller和View可以相互依赖。
* 用户对View操作以后，View捕获到这个操作，会把处理的权利交给Controller; Controller接着会执行相关的业务逻辑，这些业务逻辑可能需要对Model进行相应的操作；当Model变更以后会通过观察者模式通知View; View通过观察者模式收到Model变更消息以后会向Model请求最新的数据，然后重新更新界面。
* View是把控制权交移给Controller, 自己不执行业务逻辑。Controller执行业务逻辑并且操作Model, 但不会直接操作View, 可以说对View是无知的。View和Model的同步消息都是通过观察者模式进行的，而同步操作是由View自己请求Model的数据然后对视图进行更新。
* 把业务逻辑全部分离到Controller中，模块化程度高。当业务逻辑变更的时候，不需要变更View和Model，只需要Controller换成另一个Controller就行了。观察者模式可以做到多视图同事更新。
* Controller测试困难。View强依赖特定Model，因此无法组件化。

## 2. MVP
* MVP模式把MVC模式中的Controller换成了Presenter，View不再依赖Model层，其他依赖关系和MVC一致。
* 用户对View的操作都会从View交移给Presenter。Presenter同样的会执行相应的业务逻辑，并且对Model进行相应的操作；而这时候Model通过观察者模式把自己变更的消息传给Presenter, Presenter获取到Model变更的消息以后通过View提供的接口更新界面。
* View不再负责同步的逻辑，而是由Presenter负责。Presenter中既有业务逻辑也有同步逻辑。View需要提供操作界面的接口给Presenter进行调用。
* 便于测试，View也可以进行组件化。不过Presenter中除了业务逻辑以外，还有大量的View->Model, Model->View的手动同步逻辑，造成Presenter比较笨重，维护起来比较困难。

## 3. MVVM
* MVVM可以看作是一种特殊的MVP模式，或者说是对MVP模式的一种改良。MVVM的依赖关系和MVP一致，只不过是把P换成了VM。
* 可维护性更高，解决了MVP大量手动View和Model同步的问题，提供双向绑定机制。简化测试，因为同步逻辑是交由Binder做的，View跟着Model同时变更，所以只需要保证Model的正确性，View就正确。
* 不过对于简单的图形界面不太适用(牛刀杀鸡)。对于大型的图形应用程序，视图状态较多，ViewModel的构建和维护成本会比较高。数据绑定的声明是指令式地写在View的模版当中的，这些内容是没办法断点调试的。

