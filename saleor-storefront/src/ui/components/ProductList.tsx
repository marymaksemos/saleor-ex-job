import { ProductElement } from "./ProductElement";
import {
	Carousel,
	CarouselContent,
	CarouselItem,
	CarouselNext,
	CarouselPrevious,
} from "@/components/ui/carousel";
import { type ProductListItemFragment } from "@/gql/graphql";

interface ProductListProps {
	products: readonly ProductListItemFragment[];
}

export const ProductList = ({ products }: ProductListProps) => {
	return (
		<Carousel
			role="list"
			opts={{
				align: "start",
				loop: true,
			}}
			className="w-full overflow-hidden"
		>
			<CarouselContent>
				{products.map((product, index) => (
					<CarouselItem key={product.id} className="basis-full py-4 sm:basis-1/2 md:basis-1/3 xl:basis-1/4">
						<ProductElement product={product} priority={index < 2} loading={index < 4 ? "eager" : "lazy"} />
					</CarouselItem>
				))}
			</CarouselContent>
			<CarouselNext />
			<CarouselPrevious />
		</Carousel>
	);
};
